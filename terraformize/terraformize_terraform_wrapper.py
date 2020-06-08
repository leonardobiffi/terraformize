from python_terraform import *
from typing import Tuple, Optional


class Terraformize:

    def __init__(self, key: str, folder_path: str, terraform_bin_path: Optional[str] = None):
        """
        Will create a terraform object, create a tfstate based in a key & init the terraform directory

        Arguments:
            :param key: the key terraform will be executed in
            :param folder_path: the full path of the folder to run the terraform in
            :param terraform_bin_path: the full path of the terraform binary to use, will try to use the one at the path
            if not set
        """
        self.terraform_bin_path = terraform_bin_path
        self.tf = Terraform(working_dir=folder_path, terraform_bin_path=self.terraform_bin_path)

        # we need to init for a remote backend
        self.init_return_code, self.init_stdout, self.init_stderr = self.tf.init(dir_or_plan=folder_path, backend_config={'key': key +'/terraform.tfstate'})


    def apply(self, variables: Optional[dict] = None, parallelism: int = 10) -> Tuple[str, str, str]:
        """
        Will run a terraform apply & will pass all variables to the terraform apply as terraform variables

        Arguments:
            :param variables: the variables to pass to the terraform apply command
            :param parallelism: the number of parallel resource operations

        Returns:
            :return return_code: the return code of the terraform apply
            :return stdout: the stdout stream of the terraform apply
            :return stderr: the stderr stream of the terraform apply
        """
        if variables is None:
            variables = {}

        return_code, stdout, stderr = self.tf.apply(no_color=IsFlagged, var=variables, skip_plan=True,
                                                    parallelism=parallelism)
        return return_code, stdout, stderr

    def destroy(self, variables: Optional[dict] = None, parallelism: int = 10) -> Tuple[str, str, str]:
        """

        Arguments:
            :param variables: the variables to pass to the terraform destroy command
            :param parallelism: the number of parallel resource operations

        Will run a terraform destroy will pass all variables to the terraform destroy as terraform variables

        Arguments:

        Returns:
            :return return_code: the return code of the terraform destroy
            :return stdout: the stdout stream of the terraform destroy
            :return stderr: the stderr stream of the terraform destroy
        """
        return_code, stdout, stderr = self.tf.destroy(no_color=IsFlagged, var=variables, auto_approve=True,
                                                      parallelism=parallelism)
        return return_code, stdout, stderr

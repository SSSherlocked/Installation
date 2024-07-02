#! /opt/miniforge3/bin/python

import subprocess

def install_package(package_name):
    try:
        subprocess.check_output(["conda", "scripts", "-y", package_name])
        print("Package installed successfully!")
    except subprocess.CalledProcessError:
        print("Package installation failed.")


install_package("numpy")
install_package("pandas")
install_package("matplotlib")
install_package("plotly")

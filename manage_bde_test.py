import subprocess
print(subprocess.check_output(["manage-bde", "-protectors", "-delete", "e:", "-type", "RecoveryPassword"]))
print(subprocess.check_output(["manage-bde", "-protectors", "-add", "e:", "-rp"]))

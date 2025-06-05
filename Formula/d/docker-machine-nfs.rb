class DockerMachineNfs < Formula
  desc "Activates NFS on docker-machine"
  homepage "https:github.comadlogixdocker-machine-nfs"
  url "https:github.comadlogixdocker-machine-nfsarchiverefstags0.5.4.tar.gz"
  sha256 "ecb8d637524eaeb1851a0e12da797d4ffdaec7007aa28a0692f551e9223a71b7"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "7adcced71d07397c241cf4999adf40d17b6f773aa28fc53625df5982484d4c6e"
  end

  deprecate! date: "2025-04-27", because: :repo_archived

  def install
    inreplace "docker-machine-nfs.sh", "usrlocal", HOMEBREW_PREFIX
    bin.install "docker-machine-nfs.sh" => "docker-machine-nfs"
  end

  test do
    system bin"docker-machine-nfs"
  end
end
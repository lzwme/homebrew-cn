class Noir < Formula
  desc "Attack surface detector that identifies endpoints by static analysis"
  homepage "https:github.comnoir-crnoir"
  url "https:github.comnoir-crnoirarchiverefstagsv0.12.1.tar.gz"
  sha256 "7c0d2d00caf19049312f1b09be88b819053d732348b316e10b227126c4ab62cc"
  license "MIT"

  bottle do
    sha256 arm64_sonoma:   "f817b92fda3902c9d1868a6afe0eb0b57b6677a5312cde702f2eb55fd8028583"
    sha256 arm64_ventura:  "a155c3412d25016a4f24cf131247444e536930856791d539fab4b4948a01c39c"
    sha256 arm64_monterey: "4b17e5823f218dfe9987d3b9c513e0f032c62baa9a5c46e0e0563722ca5be7d3"
    sha256 sonoma:         "0e126a747e8f5f5ba812714ddcc185a1d0d6e0abb81b990b02e34d9336266b98"
    sha256 ventura:        "8d9c8d29fcabf2ab633c192f5444fe507c1a8b8abb97a825184cb43e4f66f061"
    sha256 monterey:       "7bf85392a6e36358289e70db81cdc1fb0d9a4ba68d182db4b3325138a3faab47"
    sha256 x86_64_linux:   "70230ff52ad55f907aae6584a9d8456cbaacb86215d0f9ece2d7a5f052276cb8"
  end

  depends_on "crystal"

  def install
    system "shards", "install"
    system "shards", "build", "--release", "--no-debug"
    bin.install "binnoir"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}noir --version")

    system "git", "clone", "https:github.comnoir-crnoir.git"
    output = shell_output("#{bin}noir -b noir 2>&1")
    assert_match "Generating Report.", output
  end
end
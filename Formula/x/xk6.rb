class Xk6 < Formula
  desc "Build k6 with extensions"
  homepage "https:k6.io"
  url "https:github.comgrafanaxk6archiverefstagsv0.19.2.tar.gz"
  sha256 "059ea134cb054fe3f8dca0af849ce7e3ed513a1cee244adb038921a3a78157df"
  license "Apache-2.0"
  head "https:github.comgrafanaxk6.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05a9d6fe9a247dbcf2cba5a0a8e2fe1eaea1197198f9e3efed7a41e935cbe1c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b05a9d6fe9a247dbcf2cba5a0a8e2fe1eaea1197198f9e3efed7a41e935cbe1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b05a9d6fe9a247dbcf2cba5a0a8e2fe1eaea1197198f9e3efed7a41e935cbe1c"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d5e3b42e6c29a404211e6e1691fb032ab2e14aab8628fab10fc437c5d6fd60"
    sha256 cellar: :any_skip_relocation, ventura:       "a2d5e3b42e6c29a404211e6e1691fb032ab2e14aab8628fab10fc437c5d6fd60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9394c2e3bd325835bcd1d0eb8cd8ee9d0413fb381c945d62a622bd1c53867e16"
  end

  depends_on "go"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdxk6"
  end

  test do
    str_build = shell_output("#{bin}xk6 build")
    assert_match "xk6 has now produced a new k6 binary", str_build
  end
end
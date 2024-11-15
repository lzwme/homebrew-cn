class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https:github.comSchnizfnm"
  url "https:github.comSchnizfnmarchiverefstagsv1.38.0.tar.gz"
  sha256 "1bf4552dd6a4eb63fa49c739d0ee18bf06c2c023a5ac00958aadf71e24fe8a49"
  license "GPL-3.0-only"
  head "https:github.comSchnizfnm.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a25d2c3600ceac01be3038e80a75733731880fb5ad536cf1f4f7735bf039bcb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "650f08b1009d79185012c8fc95b04b5ab1593d94cf649d80678688afdc119eaa"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "28a2697b8443c379fa7a474a573c2a29b2a7ba41e71c81498202b0a539cbc0d8"
    sha256 cellar: :any_skip_relocation, sonoma:        "5125290b564a8e0fcb22c6905b30d0f38080b47b5a3e47a5af89e895481ced3b"
    sha256 cellar: :any_skip_relocation, ventura:       "34690f1d0dc4248365d877334e6547be6c940be692efa087e429975b022de6ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b92933ec3f212301f6bf8a7e66a49d86de970ae9c0025997ce8fa10db6aaeeba"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"fnm", "completions", "--shell")
  end

  test do
    system bin"fnm", "install", "19.0.1"
    assert_match "v19.0.1", shell_output("#{bin}fnm exec --using=19.0.1 -- node --version")
  end
end
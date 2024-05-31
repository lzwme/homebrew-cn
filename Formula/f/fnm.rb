class Fnm < Formula
  desc "Fast and simple Node.js version manager"
  homepage "https:github.comSchnizfnm"
  url "https:github.comSchnizfnmarchiverefstagsv1.37.0.tar.gz"
  sha256 "673a107ac15787a29c84934ad97ac7b292ca5a3c52a7784f8d9e4bf83b4b9c0f"
  license "GPL-3.0-only"
  head "https:github.comSchnizfnm.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5ea888ddc1491df087da90ffc005bd1b837ee35938696e81813c48490dd09f15"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6b6e4dc36f46ccd233caf13aa2cd06099462edc845ce929afce5fb14e959317"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25f4154164cb1d2f924bed457e52a4c8ec8c7f9885487a854e2cbc54bae62f49"
    sha256 cellar: :any_skip_relocation, sonoma:         "03fd29e24099740ca67632189e645c63f4d83fb28b08f58d9df27e7e22faebc4"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4c006874b89d832389322ecd8614ab9c3f166e14c6c1f50d362d20bf971413"
    sha256 cellar: :any_skip_relocation, monterey:       "f5d42a3bec501b0239bb6c6e0251768a83393fd5708199c4d4a7094aa2e119af"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69cb9d6178c5b7b92ee1aa2c745c8e1cdfca84100609142629cf01a793cac4ca"
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
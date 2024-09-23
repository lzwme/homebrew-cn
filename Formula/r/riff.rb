class Riff < Formula
  desc "Diff filter highlighting which line parts have changed"
  homepage "https:github.comwallesriff"
  url "https:github.comwallesriffarchiverefstags3.3.1.tar.gz"
  sha256 "08a83f0f2fa075be3ef4d834e7491492972c00b71d8bbe61c42ba5e275dd35eb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d697502ad13e2ec2df949f6a7df7154dbb3d9133e23bce7ccf16a49a97886d07"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b93c937ab63bef8c9759fd8cd8c3321d13d9211b1556cb99528f183a61b910fd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "6f357477f5b8db7631317c692ab95857d4aaea9e5b225578d6fdcf99be448710"
    sha256 cellar: :any_skip_relocation, sonoma:        "45b10b34178613eabebe3cdc6dc6bc79aa9b101e311b1ba0fa16e1fce08bc541"
    sha256 cellar: :any_skip_relocation, ventura:       "d60b13d2b7a1cac2d1d08203be0eacc36aaec08041a5c26ab9f59d8651f548b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "85ca4ffbd8a0922fc0ab8898b94b5b68387e3a4e7f6d78890305fa4bbfe9f729"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_empty shell_output("#{bin}riff etcpasswd etcpasswd")
    assert_match version.to_s, shell_output("#{bin}riff --version")
  end
end
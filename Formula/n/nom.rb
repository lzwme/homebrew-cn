class Nom < Formula
  desc "RSS reader for the terminal"
  homepage "https://github.com/guyfedwards/nom"
  url "https://ghfast.top/https://github.com/guyfedwards/nom/archive/refs/tags/v2.11.0.tar.gz"
  sha256 "6acd37f644ae8e5a89dc06b805a238930e6431ce47a88ddc08e9477a48ff52aa"
  license "GPL-3.0-only"
  head "https://github.com/guyfedwards/nom.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "32685f1285a43cf42db6412ec9f87cf202cbc4dbdfde0f617c5eed012da86e57"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a035f9d49babd58c38430e995afcb4b78b16a5da56fa4e9a994ee3acfdcbd1a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5adf707a510f8798513b197bf4b1053001a67ea5925686d360623f706dd20560"
    sha256 cellar: :any_skip_relocation, sonoma:        "bc856944947d1d4fe3b55b358304f6d805336c590f82d5686b30f640dfedc125"
    sha256 cellar: :any_skip_relocation, ventura:       "6dc764d333bd8ceb3e20cf42b64b560f46bbe3b4bae26884fd82e67debbf44f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f3728386a10006f45c1ed7577322f1760852e33e700e23e2cbd09668aecd10ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7545e7fb930cc40fc60e2c5ee251b33c6bce1cce653711911c99edfe9cd8d3c8"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.version=#{version}"), "./cmd/nom"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nom version")

    assert_match "configpath", shell_output("#{bin}/nom config")
  end
end
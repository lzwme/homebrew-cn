class Fx < Formula
  desc "Terminal JSON viewer"
  homepage "https:fx.wtf"
  url "https:github.comantonmedvfxarchiverefstags36.0.2.tar.gz"
  sha256 "371578c7393f4ac0a404d1b481c6bd61caae7da4ba11fe7df7b05fe5e4c3c9da"
  license "MIT"
  head "https:github.comantonmedvfx.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "38c4dd8401dc13d0c6fdd76577b8d2a5bcf2dc05800822bf119bab66807e452a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "38c4dd8401dc13d0c6fdd76577b8d2a5bcf2dc05800822bf119bab66807e452a"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "38c4dd8401dc13d0c6fdd76577b8d2a5bcf2dc05800822bf119bab66807e452a"
    sha256 cellar: :any_skip_relocation, sonoma:        "55d435e4982f61d12202515e9931b575aff7cbce75524f1d50d4d269e73b7c5a"
    sha256 cellar: :any_skip_relocation, ventura:       "55d435e4982f61d12202515e9931b575aff7cbce75524f1d50d4d269e73b7c5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0baa93b6324a8566c9bfc070321244f326697571eec5bdaad9e22b855cede26a"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
    generate_completions_from_executable(bin"fx", "--comp")
  end

  test do
    assert_equal "42", pipe_output("#{bin}fx .", "42").strip
  end
end
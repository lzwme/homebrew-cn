class Hermit < Formula
  desc "Manages isolated, self-bootstrapping sets of tools in software projects"
  homepage "https://cashapp.github.io/hermit"
  url "https://ghfast.top/https://github.com/cashapp/hermit/archive/refs/tags/v0.48.1.tar.gz"
  sha256 "2aa8b404ab351d21a02df8f6cef99307292c07f8ecdbe7dd129df7e17f50a230"
  license "Apache-2.0"
  head "https://github.com/cashapp/hermit.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "63c9ea2e69549cce0cd28d172ae6306e492d74125aa92465e776372dac0d07ba"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d176ed5616e873528f39482aad518fb258a84832b65183f26e18a88c3add8514"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c91aa53b6e246141775bce978e66aa3e81a59535880b3a5554ae16074bf530e4"
    sha256 cellar: :any_skip_relocation, sonoma:        "e214a7356cd57f416a018e8a0e882bb9d7952b73c72e0d345d774ded20846c22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e014493acdd71e51b466005045c61270d43e5ede64d6d4ad77237dd439779950"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "140591338735bbdc5c08855ed95e722d9c4d9ddff7961e564387e4ed79ee0692"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.channel=stable
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/hermit"
  end

  def caveats
    <<~EOS
      For shell integration hooks, add the following to your shell configuration:

      For bash, add the following command to your .bashrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --bash)"

      For zsh, add the following command to your .zshrc:
        eval "$(test -x $(brew --prefix)/bin/hermit && $(brew --prefix)/bin/hermit shell-hooks --print --zsh)"
    EOS
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hermit version")
    system bin/"hermit", "init", "."
    assert_path_exists testpath/"bin/hermit.hcl"
  end
end
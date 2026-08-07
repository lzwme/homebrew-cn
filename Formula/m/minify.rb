class Minify < Formula
  desc "Minifier for HTML, CSS, JS, JSON, SVG, and XML"
  homepage "https://go.tacodewolff.nl/minify"
  url "https://ghfast.top/https://github.com/tdewolff/minify/archive/refs/tags/v2.24.16.tar.gz"
  sha256 "de64a187693fb465cf70086defbcaee66934041d23aeeda7485a53125eaab6f3"
  license "MIT"
  head "https://github.com/tdewolff/minify.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f2e956cac6df60f39efa6e909b196915c7ca3edca7b1dcf9e665f7997a527a73"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f2e956cac6df60f39efa6e909b196915c7ca3edca7b1dcf9e665f7997a527a73"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f2e956cac6df60f39efa6e909b196915c7ca3edca7b1dcf9e665f7997a527a73"
    sha256 cellar: :any_skip_relocation, sonoma:        "eed3eef6c24e54aff6ba51c4c531f0896cb601fbe07d5237aa09c736c7381e91"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "1ab592acb826a85f4502ad10710904b52d66cdbc99395527cacb7cb73ec24f27"
    sha256 cellar: :any,                 x86_64_linux:  "40055eac6a3e27b16fe6d4024cc2f60526aa55bbc89f35871f759e953297eea9"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.Version=#{version}"), "./cmd/minify"
    bash_completion.install "cmd/minify/bash_completion"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/minify --version")

    (testpath/"test.html").write <<~HTML
      <div>
        <div>test1</div>
        <div>test2</div>
      </div>
    HTML
    assert_equal "<div><div>test1</div><div>test2</div></div>", shell_output("#{bin}/minify test.html")
  end
end
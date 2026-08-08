class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.23.0.tar.gz"
  sha256 "e10be7f48202feab3e42489efe8e5803ad85b44c304b1899eeade3545b0b0d44"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e59a4be7d0b786831f0aa0299d4d34d962ade7bb7ea2ebdbf0165da33c5a0a6b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "23ff8ac875c000618ba3e5b6dc2ac3c74e44d41a462267e95ead892134ab3ef3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "72b2726586b3fc3a5eaf9d01316218fe19bc646511009be803e82a4df67c3639"
    sha256 cellar: :any_skip_relocation, sonoma:        "9df2b7a5f21c54ec397b3f1169eb7b56f4b15fe8dc165d7bccf5a62f83974f50"
    sha256 cellar: :any,                 arm64_linux:   "00b6afe2e36e5dca4345597dbc641a7824a20dc9e0f1c96cebe4cca15206c58f"
    sha256 cellar: :any,                 x86_64_linux:  "ef948203880d90f8fdc7ed1e9be876e93ce0dbb648f259d477b6ada152900dda"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin/"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath/"test.jinja").write <<~JINJA
      Hello {{ name }}
    JINJA

    assert_equal "Hello Homebrew\n", shell_output("#{bin}/minijinja-cli test.jinja --define name=Homebrew")
  end
end
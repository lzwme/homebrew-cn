class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https://docs.rs/minijinja/latest/minijinja/"
  url "https://ghfast.top/https://github.com/mitsuhiko/minijinja/archive/refs/tags/2.22.0.tar.gz"
  sha256 "c7a5bae5afae29987e948ea14ad4ad8c5dfc0ea2ad98e40d9eef5636da38baf2"
  license "Apache-2.0"
  head "https://github.com/mitsuhiko/minijinja.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end
  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "0d96ff669a6a290030982db2f48c399904339ef3fda27dc5c8ba8ddf81c8a728"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4633dd06f64d05c22fe3ccaa13ee2321d8665cd86a5e02aeecaa1ab9915d5c3e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cf33c6fc94c5d94280a5f92e32a1d6bf57dcd2897c96868300ddb07254f22c41"
    sha256 cellar: :any_skip_relocation, sonoma:        "ee586223d875e7a575caf4331c247c857987f5f9567e08857fe0eb1af10608d7"
    sha256 cellar: :any,                 arm64_linux:   "bdc30cf8f77cde83cf77b6d7fd8e15244d8571617ee42f39c4606e4719213c1f"
    sha256 cellar: :any,                 x86_64_linux:  "50a08d8449785d3aa5b88a259de6888156ebb5fd75e384e484a6dd3b62e2b9a5"
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
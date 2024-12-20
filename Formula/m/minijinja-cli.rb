class MinijinjaCli < Formula
  desc "Render Jinja2 templates directly from the command-line to stdout"
  homepage "https:docs.rsminijinjalatestminijinja"
  url "https:github.commitsuhikominijinjaarchiverefstags2.5.0.tar.gz"
  sha256 "63e9f1ece32cc7edea5fc762e3bfe48571f71ec3b112cc8f7b0c1a1619dab81e"
  license "Apache-2.0"
  head "https:github.commitsuhikominijinja.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5cd46a4e0a68200b5e87bde1cf6a470f7ad0a3b5731ef430e50f43ac2f8b5bc5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9afbf60092ec8ac6b8b7fe1648573dbf69707802dfe3b59db766a871059c3927"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d286e3107104d42bfee64e93f094dc440b98a9efe86f5c8463650054cb5fb189"
    sha256 cellar: :any_skip_relocation, sonoma:        "26f61e55e39e6675507da50b25ab0bd5d207498d5f0cfae773ad04112263f972"
    sha256 cellar: :any_skip_relocation, ventura:       "e49183d2971cf5c20adfcd29fb4a622a82eb58fb2c8975247d3e74d552fe297a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea17b0761685c64cf1652b8904551ce2c785173b720a2b0c1f4d5d67d39b5c38"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "minijinja-cli")

    generate_completions_from_executable(bin"minijinja-cli", "--generate-completion")
  end

  test do
    (testpath"test.jinja").write <<~EOS
      Hello {{ name }}
    EOS

    assert_equal "Hello Homebrew\n", shell_output("#{bin}minijinja-cli test.jinja --define name=Homebrew")
  end
end
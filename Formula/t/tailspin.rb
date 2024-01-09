class Tailspin < Formula
  desc "Log file highlighter"
  homepage "https:github.combensadehtailspin"
  url "https:github.combensadehtailspinarchiverefstags2.3.0.tar.gz"
  sha256 "f523a9ccf59e6d5ae4bb66a5b0a4d480832f604c09a3c2f4dd00b5efc8f1b03d"
  license "MIT"
  head "https:github.combensadehtailspin.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e128720d800f6e3e302215f8174befab566505719bfec352c021f4dcc3734de6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9cc98ce126e50615b8b57f8a645fd3866e19df9b2986e157e54172f931462493"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8c2458dfe94b46578e3088bc5001424ab84813164275264b33068a1d16d1aee5"
    sha256 cellar: :any_skip_relocation, sonoma:         "89fd1f0a5571f34f4d9b0644d4727d135e613a5bc94a497429f91f13f645e641"
    sha256 cellar: :any_skip_relocation, ventura:        "8ee644d36974e8a4298a423719881b4b89ce87e3be8f54c7682e4cad93a02417"
    sha256 cellar: :any_skip_relocation, monterey:       "7f2f48d3ae3ac4d37d4b0d92e3fbbd74ad854bdfc2d5616025cf17e0263475b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8e4ca1ed9da56611d825e6eaae79b28b5f9b071b8f3302892f20a97b7e728db"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin"tspin", "--z-generate-shell-completions")
    man1.install "mantspin.1"
  end

  test do
    output = shell_output("#{bin}tspin --start-at-end 2>&1")

    expected = if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]
      ""
    else
      "Missing filename"
    end
    assert_match expected, output

    assert_match version.to_s, shell_output("#{bin}tspin --version")
  end
end
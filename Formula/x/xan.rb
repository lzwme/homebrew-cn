class Xan < Formula
  desc "CSV CLI magician written in Rust"
  homepage "https:github.commedialabxan"
  url "https:github.commedialabxanarchiverefstags0.49.1.tar.gz"
  sha256 "a17cd8cc0463548541d2aadb0f2f559ec9d6cb3e58463ee32e4e50e09677a8a7"
  license any_of: ["MIT", "Unlicense"]
  head "https:github.commedialabxan.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ac3b4c193ec9cd526b82cbcf0432ef0636e18655298a51208be4ca351cea9741"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ee388196d8ca8173f9d7c355463eb706708af3510701a7835b2299a52e308ddd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "632354dd57a81a7d2b0962b23f948519fc71e1b54f1257739bf4777303cc10a8"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fc9b0ec46fe76ea631faae3ef99e2000fb08b1fff7455553814b2a90a38e960"
    sha256 cellar: :any_skip_relocation, ventura:       "4113930d3c299d59ed84cc5edade1d6f9b690ec1b006c60088f54b745bf83c6c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "45c9c6bb6637671e2d6c977b43f54539e64983bcccacaf962a7dcf1059489b32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4a417e602253de7505597906e77d28760c45e4877327f9399304f74f13297237"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath"test.csv").write("first header,second header")
    system bin"xan", "stats", "test.csv"
    assert_match version.to_s, shell_output("#{bin}xan --version").chomp
  end
end
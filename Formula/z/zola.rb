class Zola < Formula
  desc "Fast static site generator in a single binary with everything built-in"
  homepage "https:www.getzola.org"
  url "https:github.comgetzolazolaarchiverefstagsv0.19.1.tar.gz"
  sha256 "9926c3e7c64ee20a48dc292785c5a29f387c1fab639005ced894982f9c3d7258"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "bfceff7dacbb356ff1114d4c72db21094032026574bb5ba450f2c2a0ccb55709"
    sha256 cellar: :any,                 arm64_ventura:  "9e13b76a2b6c56228c8959c196c4b076f0e04ec1dcfe71e1969f928c2782b272"
    sha256 cellar: :any,                 arm64_monterey: "74246794a4f0d3a017eb6b97bf77257d3381e3aff95173f2e4d068b72e8a9818"
    sha256 cellar: :any,                 sonoma:         "a36fcbc3c54569cdd52ff7aa547df388b60f7a89945bccde9f6c5a316fe64dc1"
    sha256 cellar: :any,                 ventura:        "57843d05bcac5c01d0996466bf8b4d66d5bebe8b10056aaad5f49b5f96a876d9"
    sha256 cellar: :any,                 monterey:       "b8c5f07fdac086d975824469066987feb4ab79d173a725774ac31745793459bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25ef9f5d9e5aab6f4383c83d8958c0407143b69f72cf043c3ce5386b0c1015f4"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "oniguruma" # for onig_sys

  on_linux do
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    ENV["RUSTONIG_SYSTEM_LIBONIG"] = "1"
    system "cargo", "install", "--features", "native-tls", *std_cargo_args

    generate_completions_from_executable(bin"zola", "completion")
  end

  test do
    system "yes '' | #{bin}zola init mysite"
    (testpath"mysitecontentblog_index.md").write <<~EOS
      +++
      +++

      Hi I'm Homebrew.
    EOS
    (testpath"mysitetemplatessection.html").write <<~EOS
      {{ section.content | safe }}
    EOS

    cd testpath"mysite" do
      system bin"zola", "build"
    end

    assert_equal "<p>Hi I'm Homebrew.<p>",
      (testpath"mysitepublicblogindex.html").read.strip
  end
end
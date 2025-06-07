class TomlBombadil < Formula
  desc "Dotfile manager with templating"
  homepage "https:github.comoknozortoml-bombadil"
  url "https:github.comoknozortoml-bombadilarchiverefstags4.2.0.tar.gz"
  sha256 "b911678642a1229908dfeabbdd7f799354346c0e37f3ac999277655e01b6f229"
  license "MIT"
  head "https:github.comoknozortoml-bombadil.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "1162919902e899ebeb320fd04132856443deb257f47a073be4bc916dfff322c7"
    sha256 cellar: :any,                 arm64_sonoma:  "5142e942e2bcf7d79a0935e77e1f1dca2c812a60311ef4b429e60b0606e7042a"
    sha256 cellar: :any,                 arm64_ventura: "b4e073f82e21d3a73f1ca641524f1cd5b10891dba22e4db989aa1909cafa2477"
    sha256 cellar: :any,                 sonoma:        "a26d4a4ac5a06a3ebaf3ccf6e6c54f1c8d37faed1fb33f43a2ee89c448aa4df5"
    sha256 cellar: :any,                 ventura:       "e1b81c25d689463b534a94f6d6d3a0ccf9987eed52b874e8c4a8f80891b5fa71"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "afbfb3763e73ccf60daddd2d636827817ef09d072f4de66a5bae6bb54362cd36"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "63847b627610a6981f8afe87c9de344b1cad2ac95a6fdfaff3af7b8071235d7a"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    config_dir = if OS.mac?
      testpath"LibraryApplication Support"
    else
      testpath".config"
    end

    config_dir.mkpath
    (config_dir"bombadil.toml").write <<~TOML
      dotfiles_dir = "dotfiles"
    TOML

    (testpath"dotfiles").mkpath

    ENV["HOME"] = testpath

    output = shell_output("#{bin}bombadil get vars")

    assert_match("arch":\s*".+", output)
    assert_match("os":\s*".+", output)
  end
end
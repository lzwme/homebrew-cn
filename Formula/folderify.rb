class Folderify < Formula
  desc "Generate pixel-perfect macOS folder icons in the native style"
  homepage "https://github.com/lgarron/folderify"
  url "https://ghproxy.com/https://github.com/lgarron/folderify/archive/refs/tags/v3.0.9.tar.gz"
  sha256 "40d94a9c02d4fcd777fccb989b4bda4ceec8b3f913e786fcf4c78226fbbf1df4"
  license "MIT"
  head "https://github.com/lgarron/folderify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e1b7a13bfb29c9bec79fca3bcd86ee0f2703de80cf5d65f61d1489385c272ba5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eddca7b8fca81cd3da96399e42ae2447020a2dc65e3e954e1a1316d1b8295c48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea962646965b1ad1b989efc4a68cd01a8c971b09346cc3f226d834ae7c5997f5"
    sha256 cellar: :any_skip_relocation, ventura:        "8aa79084a077d713032409ea37335f996f39574724de3a7b952eb613414bf5d0"
    sha256 cellar: :any_skip_relocation, monterey:       "736edaa4e1f2202c4e146afaac6b2c27fa374700a2c60d40027e367f6848f302"
    sha256 cellar: :any_skip_relocation, big_sur:        "a1071a902629fbd9e98b84b0799a079ad3f1f69bd595da9d4481d57c3ab2ba11"
  end

  depends_on "rust" => :build
  depends_on xcode: :build
  depends_on "imagemagick"
  depends_on :macos

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"folderify", "--completions")
  end

  test do
    # Write an example icon to a file.
    File.write("test.svg", '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100">
      <circle cx="50" cy="50" r="40" fill="transparent" stroke="black" stroke-width="20" /></svg>')

    # folderify applies the test icon to a folder
    system bin/"folderify", "test.svg", testpath.to_s
    # Tests for the presence of the file icon
    assert_predicate testpath / "Icon\r", :exist?
  end
end
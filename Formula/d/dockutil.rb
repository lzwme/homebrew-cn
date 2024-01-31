class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https:github.comkcrawforddockutil"
  url "https:github.comkcrawforddockutilarchiverefstags3.1.2.tar.gz"
  sha256 "f21d30407473c7a9d6022225739c14faafa27a2a43c1a26643a7e5a4d508596a"
  license "Apache-2.0"
  head "https:github.comkcrawforddockutil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a572eeeac51a0783b173fa3f07690caaebeba10dc2679cb321f0eaf930cf436"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd3d9ceeeb1aa2359eacdae35a0a879901a179ba5239d800936154f1d60444af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3fb9f59780f364e8b404e0dc525dcfecfa984399355e557dfd83aa025841244"
    sha256 cellar: :any_skip_relocation, sonoma:         "8f4af91374343616f77701928a40ff13438edc46699fee807a274da0f5600ecf"
    sha256 cellar: :any_skip_relocation, ventura:        "d96ab41167de3511504cef917bcd1ac9a1713ba3313d491092601184662743ef"
    sha256 cellar: :any_skip_relocation, monterey:       "84967e21965760c3ded00a353796d3e7073e10fcc563cb730edec5ca94e9a86e"
  end

  depends_on xcode: ["13.0", :build]
  depends_on :macos
  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleasedockutil"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockutil --version")
  end
end
class Dockutil < Formula
  desc "Tool for managing dock items"
  homepage "https:github.comkcrawforddockutil"
  url "https:github.comkcrawforddockutilarchiverefstags2.0.5.tar.gz"
  sha256 "6dbbc1467caaab977bf4c9f2d106ceadfedd954b6a4848c54c925aff81159a65"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f5f87d9e286c2b294bb157ac9f87baa2720fff044c7a92c0b80b9cb82db8a87e"
  end

  head do
    url "https:github.comkcrawforddockutil.git", branch: "main"

    depends_on xcode: ["13.0", :build]

    uses_from_macos "swift"
  end

  # https:github.comkcrawforddockutilpull131
  # https:github.comHomebrewhomebrew-corepull97394
  deprecate! date: "2023-09-03", because: :does_not_build

  depends_on :macos

  def install
    if build.head?
      system "swift", "build", "--disable-sandbox", "--configuration", "release"
      bin.install ".buildreleasedockutil"
    else
      bin.install "scriptsdockutil"
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}dockutil --version")
  end
end
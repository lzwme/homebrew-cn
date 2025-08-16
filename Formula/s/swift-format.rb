class SwiftFormat < Formula
  desc "Formatting technology for Swift source code"
  homepage "https://github.com/swiftlang/swift-format"
  url "https://github.com/swiftlang/swift-format.git",
      tag:      "601.0.0",
      revision: "ffbb3225ffda37b62c7283c70e87e8bc7e8e202a"
  license "Apache-2.0"
  version_scheme 1
  head "https://github.com/swiftlang/swift-format.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "548eaeeadc2ca4bcd4328bcababf9df8e53f07cf750f2f38895f3bd60f00de2a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c09eaa3970ce73f7e4e6a4a9ab31f7fcad525b433d8cf4db89bc63079126db8e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5e845064494c8db5d56782b08febc4f4516f4c4d6ea2fe80ae4148fe554299a7"
    sha256 cellar: :any_skip_relocation, sonoma:        "0776bbd9d05f899a24c1f465c90078f87e31ccb156af92c8a56e4d1ee40e8d97"
    sha256 cellar: :any_skip_relocation, ventura:       "26ae3f5e9124087966fe7c3d34ce6f54723ecdd3225aab16be727932322c9b04"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f83de88ab0808563400c502abebbe1cb93c3e45ad19ae83bae6440175d7d9c91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b04de614adadd6a2d2e8430b9bdd04117dc75a7c4d62077183352b12ae0ca9"
  end

  # The bottles are built on systems with the CLT installed, and do not work
  # out of the box on Xcode-only systems due to an incorrect sysroot.
  pour_bottle? only_if: :clt_installed

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "-c", "release", "--product", "swift-format"
    bin.install ".build/release/swift-format"
    doc.install "Documentation/Configuration.md"
    generate_completions_from_executable(bin/"swift-format", "--generate-completion-script")
  end

  test do
    (testpath/"test.swift").write " print(  \"Hello, World\"  ) ;"
    assert_equal "print(\"Hello, World\")\n", shell_output("#{bin}/swift-format test.swift")
  end
end
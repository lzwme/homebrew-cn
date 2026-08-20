class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.9.6.tar.gz"
  sha256 "66aaff46969bc8174d7f73280d2775be0c93ba46c9411ef2bf20a8b42f52f677"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "c4046584a7b91877c837beef43046b71d02ce584b04e6b1e5bdaada9be5c436c"
    sha256                               arm64_sequoia: "d55e6c03586e89aa9530ed21ce9e7afd56f6bcde2b6b2481f70fd737a8997d28"
    sha256                               arm64_sonoma:  "1f52527859dcdf85443509cc2d5612c8dc5e6e5c626bd8ff6049fd25753faed1"
    sha256 cellar: :any_skip_relocation, sonoma:        "541d860027fb028238718c4469e51af415137711e1ae6ca98efc302135af291f"
    sha256                               arm64_linux:   "c75d8fce97af326e78bf9c2158902e760b63c18c838ae4b516bfca60a70b5cd9"
    sha256                               x86_64_linux:  "e31f04521345ef76f988f1549d0685d8fd7b4bdba952a73089d952659042899f"
  end

  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_macos do
    depends_on xcode: :build
  end

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.9.6.tar.gz"
    sha256 "473b61a222fc9eddb14a5097742c700137c4c046b9100178cdfd6dca57dc259e"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    system "swift", "build", "--product", "SkipRunner", *std_swift_args
    bin.install ".build/release/SkipRunner" => "skip"
    generate_completions_from_executable(bin/"skip", "--generate-completion-script")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/skip version")
    system bin/"skip", "welcome"
    system bin/"skip", "init", "--no-build", "--transpiled-app", "--appid", "some.app.id", "some-app", "SomeApp"
    assert_path_exists testpath/"some-app/Package.swift"
  end
end
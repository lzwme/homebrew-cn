class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.16.tar.gz"
  sha256 "7af8e76a5852b9f922e19fdbc51f2129655977fdac5f50ecadc1477d7763df8a"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "97a97126b62cb1c8744057adc8de4f4212e23dbd0647609743dc0ef26b05f1f8"
    sha256                               arm64_sequoia: "256d55595c22802a1b36fc051656b3b69cdedc6a8b5e1254398770125eba20a0"
    sha256                               arm64_sonoma:  "3cc5738b1d3e1da56b0a94eb21e9795454c725fe14ad8647092b66ce98d3a4a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "c3bf6ffe97e9a6ec78f4c021ff4555d26dc41aaa94861ee5708bd607445cbb2b"
    sha256                               arm64_linux:   "084a7b008b8c87ab79ddd65ffd497eb01f94d6a75654d5c376b95261dd3d195d"
    sha256                               x86_64_linux:  "40adf72d26d19a62c5abaf6acb71135382d1bd82cd47b64a9e234edb1e114943"
  end

  depends_on xcode: :build
  depends_on "gradle"
  depends_on "openjdk"
  depends_on "swiftly"

  uses_from_macos "swift" => [:build, :test]
  uses_from_macos "curl"
  uses_from_macos "libxml2"

  on_linux do
    depends_on "libarchive"
    depends_on "zlib-ng-compat"
  end

  resource "skipsubmodule" do
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.16.tar.gz"
    sha256 "99b75f5ab48517efb27368e7d50f90d0f000a3ae7ee3d05ba7299959902f3e9e"

    livecheck do
      formula :parent
    end
  end

  def install
    resource("skipsubmodule").stage buildpath/"skip"

    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib", "-Xswiftc", "-use-ld=ld"]
    end
    system "swift", "build", *args, "--configuration", "release", "--product", "SkipRunner"
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
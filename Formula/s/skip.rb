class Skip < Formula
  desc "Tool for building Swift apps for Android"
  homepage "https://skip.dev"
  url "https://ghfast.top/https://github.com/skiptools/skipstone/archive/refs/tags/1.8.18.tar.gz"
  sha256 "62068bb19a48793987fcbce4f0b051a13ddf5e16edbf86dd9e6fc1d5c766bf2f"
  license "AGPL-3.0-only"
  head "https://github.com/skiptools/skipstone.git", branch: "main"

  bottle do
    sha256                               arm64_tahoe:   "d2c785ebe2fa48a7a797f5e379fdc35fbf095c44631c99dc82bb4ded38ce70dd"
    sha256                               arm64_sequoia: "e722a7db86604138605ee7d89fafc1fa4355f5aa58ecdedc1fd40bda3413bbeb"
    sha256                               arm64_sonoma:  "7197dfa223fcd61859364245bd250edc7805d2e94c2fb4c3c1577627c2033731"
    sha256 cellar: :any_skip_relocation, sonoma:        "4bcf3ca6742d7c86ea5ae3c5aa7577b3ec4e95fa4cc270dc96ba153d0a0e09c6"
    sha256                               arm64_linux:   "c0698eb045a170341775c6e92a30c8409a54356dd8a5ec56ef9ca791493f8d14"
    sha256                               x86_64_linux:  "a51bab6b877a958fd4da0ae2471e88ae2cf11b2fb0b79a43820bf5fa06c45ae7"
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
    url "https://ghfast.top/https://github.com/skiptools/skip/archive/refs/tags/1.8.18.tar.gz"
    sha256 "39968be24e902ed826ea46c091be94c8760a1bbb340d0b76210fff87acf29d99"

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
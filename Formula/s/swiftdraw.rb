class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https:github.comswhittySwiftDraw"
  url "https:github.comswhittySwiftDrawarchiverefstags0.19.0.tar.gz"
  sha256 "17fa99b6e7e4d1ce556af5903b93d00f23d7fc9baa39d4038562e6278af52558"
  license "Zlib"
  head "https:github.comswhittySwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4ce592b977ff2760ee21403b7d24a7f84fed3d1c748b7e77a6506f2a07c79f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "32d96fa1995cc9e11e85366b513cdc5e71a6097856214f332552b032b3ebbbd8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "2c2c92ae072b567ec4b00aabb5509f002f9c2bda3b5aad64d1ddcc2737f05006"
    sha256 cellar: :any_skip_relocation, sonoma:        "ef22f3a2698093ef006bcb42af6a34b9a413b2522c3bb1aab236776bd896a2bf"
    sha256 cellar: :any_skip_relocation, ventura:       "753cdba79222ce445b2366903bced65f7d8ab14001e6ba42bcce2406a05c6acb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "da825bfc8cf39cbc5bcff4a95ec72d852fa348d2ca1db5861246c9938848f6f4"
  end

  depends_on xcode: ["14.0", :build]

  uses_from_macos "swift" => :build
  uses_from_macos "libxml2"

  def install
    args = if OS.mac?
      ["--disable-sandbox"]
    else
      ["--static-swift-stdlib"]
    end
    system "swift", "build", *args, "--configuration", "release"
    bin.install ".buildreleaseswiftdrawcli" => "swiftdraw"
  end

  test do
    (testpath"fish.svg").write <<~EOS
      <?xml version="1.0" encoding="utf-8"?>
      <svg version="1.1" xmlns="http:www.w3.org2000svg" width="160" height="160">
        <path d="m 80 20 a 50 50 0 1 0 50 50 h -50 z" fill="pink" stroke="black" stroke-width="2" transform="rotate(45, 80, 80)">
      <svg>
    EOS
    system bin"swiftdraw", testpath"fish.svg", "--format", "sfsymbol"
    assert_path_exists testpath"fish-symbol.svg"
  end
end
class Swiftdraw < Formula
  desc "Convert SVG into PDF, PNG, JPEG or SF Symbol"
  homepage "https:github.comswhittySwiftDraw"
  url "https:github.comswhittySwiftDrawarchiverefstags0.18.2.tar.gz"
  sha256 "9b192a49f94876b9f28e127cb30e4f7152f0a95f64639f40e4117eaf7f1d77e4"
  license "Zlib"
  head "https:github.comswhittySwiftDraw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8fd6977293360722cb61cde12665b07c2998d34c27509aa8e6793ed8e8e7cec5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9e2c75d4cbda8f7180dfc127a4f56d4846abdb85a1650ce521f3996599e08aa8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "62255703dd6b55eabe728a04654986bd270931f887fe4c06d109748b99b58d75"
    sha256 cellar: :any_skip_relocation, sonoma:        "5a6ac922fe5306d08c48b573d2c85ced106403d813eadfd9c5a980691033d605"
    sha256 cellar: :any_skip_relocation, ventura:       "1b8e1775a2e2a80865bde384b60870abd59fa2e85f1655badd6c22883e46bbd4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8f9872caf0c34680beeec2977dbb8aaa44339caa6c7b51071c2826f1ae2e9d05"
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
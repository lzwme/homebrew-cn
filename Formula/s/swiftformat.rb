class Swiftformat < Formula
  desc "Formatting tool for reformatting Swift code"
  homepage "https:github.comnicklockwoodSwiftFormat"
  url "https:github.comnicklockwoodSwiftFormatarchiverefstags0.53.0.tar.gz"
  sha256 "7aaec00a8263620c78cbaa4d22828040608ac20bd88b1cab02c05c68c018e87c"
  license "MIT"
  head "https:github.comnicklockwoodSwiftFormat.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "aa82d01460cb74f18d6a7883f1d0238376021f688d8b9b6d4a957d268c0168b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e523a4a0eb43355c54bf957bd46efe114c3d57d59baca6bac45945be052f3f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1793afbeafcb6fe60d8255df281330377a2f371ef60a9b7416e431b2927f17f5"
    sha256 cellar: :any_skip_relocation, sonoma:         "0405f4bcc38dab6929e121a8325f4a9f3466c5877319405bf5be3113ca0da440"
    sha256 cellar: :any_skip_relocation, ventura:        "b657bf5179f3a3f37034a4ac8fa6cf2034e26b299893962abe6a5797056419da"
    sha256 cellar: :any_skip_relocation, monterey:       "49c4ad218030c4838c6f580c756361ad2f7aafbe5e3bcf066852eb301b9da1c4"
    sha256                               x86_64_linux:   "7902b0f146262c46433aaa2289eab30d133bcbcd83ec3dfdd9f182a39d087ebe"
  end

  depends_on xcode: ["10.1", :build]

  uses_from_macos "swift"

  def install
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".buildreleaseswiftformat"
  end

  test do
    (testpath"potato.swift").write <<~EOS
      struct Potato {
        let baked: Bool
      }
    EOS
    system "#{bin}swiftformat", "#{testpath}potato.swift"
  end
end
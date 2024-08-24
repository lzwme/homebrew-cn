class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https:github.comcrate-citypos"
  url "https:github.comcrate-cityposarchiverefstagsv1.24.1.tar.gz"
  sha256 "738ce31be2ed84a41b07b3f7268dbfefc1c7deae4b64c46bc28ba01acb66b97e"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "59cd4ec192168434b5105ca3e64fb5190d10773305eb502d319d6b6c56e5f1b4"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8428244c425d6d0279847ef761762ed5f0ca375d9d2cbf253df09a5dd2c47869"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "06d5a6b69f4c335cbe89686b83dfc8a75962585235b931952fd8b7552aefc738"
    sha256 cellar: :any_skip_relocation, sonoma:         "6f5c2c3ad1994ac62db38eda5de06604b6e51283204b5413d2417a81ae700373"
    sha256 cellar: :any_skip_relocation, ventura:        "a9d334438cfd9c4638131d04ff87ae215fadad73f1227ec527d0340d5f930a1c"
    sha256 cellar: :any_skip_relocation, monterey:       "3645e761f6597423eae9a0026150be9dbd6ff9b0e01a382241e27057e6c48bb4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74421eb2b5b405c7d65580e309fcd14dbdf2244924daf9154896bc6b96f9b338"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cratestypos-cli")
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}typos -", "teh", 2)
    assert_empty pipe_output("#{bin}typos -", "the")
  end
end
class Fuc < Formula
  desc "Modern, performance focused unix commands"
  homepage "https:github.comsupercilexfuc"
  url "https:github.comsupercilexfucarchiverefstags3.0.0.tar.gz"
  sha256 "b2825320a48405a350892844962675583e9012f82a06a3a5d1ff2e3c30547b5b"
  license "Apache-2.0"
  head "https:github.comsupercilexfuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "86d9d1dc0f7d14e94c96b1cf9d0b22236acd5b80e1276e9d65c3a59adc02e95f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "fd47e98fe868afca3b027a8f567733333916a19225835bce89f3ff6bf37ce3b7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a17c23cff1c7c2ef98c1126ac60bcdc5da25b1c18e47c37a78d1060198885757"
    sha256 cellar: :any_skip_relocation, sonoma:        "de4962eae3538895f2b8bc448a892058812d9b36b585a1a995bdf55c5d81eea4"
    sha256 cellar: :any_skip_relocation, ventura:       "445c5736bf0431dc37cd7ea77f7aad5f8f485cc034b19f2f86bd9dac1389ebfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bd8cac7b6a48a89f310c1de2e68496177f1417602bf75a4df31ed19c6d1c71a9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "cpz")
    system "cargo", "install", *std_cargo_args(path: "rmz")
  end

  test do
    system bin"cpz", test_fixtures("test.png"), testpath"test.png"
    system bin"rmz", testpath"test.png"

    assert_match "cpz #{version}", shell_output("#{bin}cpz --version")
    assert_match "rmz #{version}", shell_output("#{bin}rmz --version")
  end
end
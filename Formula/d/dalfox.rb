class Dalfox < Formula
  desc "XSS scanner and utility focused on automation"
  homepage "https://dalfox.hahwul.com"
  url "https://ghfast.top/https://github.com/hahwul/dalfox/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "ffd6c0ebb576c80150a0abfeb1830f84e8254ff2089e4617bb1748a91754e590"
  license "MIT"
  head "https://github.com/hahwul/dalfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9939fba35d5dfa5bdc73af1fa42ce71de79f836b9665ac5bc2c4f24d0a3ec286"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cd78dd6844102f89771ca572377a71c1e8fcbab9f11ad2b79586ac850cbec3da"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d567d20aa6bb174fb0f617c6151870a1ac97a6b596ba9fe78e99c40bf872258d"
    sha256 cellar: :any_skip_relocation, sonoma:        "05254ca9efb8fc7061ed012289b06d268de5baa03878346370a5f19d735f31cf"
    sha256 cellar: :any,                 arm64_linux:   "fa4f78f4ba76cfbda5186844600ff234a41bda2df6946a09f154b95590a54924"
    sha256 cellar: :any,                 x86_64_linux:  "6ceffaa527c7e49b00714972875657d0bf3aa953cf3885ce3abb9d6cf67d7108"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dalfox -V 2>&1")

    url = "https://pentest-ground.com:4280/vulnerabilities/xss_r/"
    output = shell_output("#{bin}/dalfox scan \"#{url}\" 2>&1")
    assert_match "scan completed", output
  end
end
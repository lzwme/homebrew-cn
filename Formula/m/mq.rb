class Mq < Formula
  desc "Jq-like command-line tool for markdown processing"
  homepage "https://mqlang.org/"
  url "https://ghfast.top/https://github.com/harehare/mq/archive/refs/tags/v0.8.2.tar.gz"
  sha256 "68bba94b14048fc956b987e1b5dd7f8f94f175cdbea41e768247132c194f664c"
  license "MIT"
  head "https://github.com/harehare/mq.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "761133ea9685bd7a24776d9f8d0f760156d21e1e447fb8075bd7b9147235a4ad"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3effbe9e5b01749d340172ca1ed00109125aeea86062e631181436a0cddcbdbd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3fab5e6eb0e97f4afdb131b1c930b7dd1cf7686b5065470f97f2a0d496281825"
    sha256 cellar: :any_skip_relocation, sonoma:        "f70e2c7cb57244b85d71a6cd03a6cf9079f13d363a44575ba3893ee60ff93e4f"
    sha256 cellar: :any,                 arm64_linux:   "2d17a81e88aaf2cfd496972d7c437d30932ea8a34f2b9bf91135cbfbfe5b1fb0"
    sha256 cellar: :any,                 x86_64_linux:  "bae860ff690dd74942e0c1e7c34367e5b39be6bc2579ac2e824fb0c914889738"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/mq-run")
    system "cargo", "install", *std_cargo_args(path: "crates/mq-lsp")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mq --version")

    (testpath/"test.md").write("# Hello World\n\nThis is a test.")
    output = shell_output("#{bin}/mq '.h' #{testpath}/test.md")
    assert_equal "# Hello World\n", output
  end
end
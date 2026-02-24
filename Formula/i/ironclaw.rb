class Ironclaw < Formula
  desc "Security-first personal AI assistant with WASM sandbox channels"
  homepage "https://github.com/nearai/ironclaw"
  url "https://ghfast.top/https://github.com/nearai/ironclaw/archive/refs/tags/v0.11.1.tar.gz"
  sha256 "343105586d03b8791bd9b0cada70c0967ab7651c1008d93b7aca91704eca6c53"
  license any_of: ["MIT", "Apache-2.0"]
  head "https://github.com/nearai/ironclaw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "75d85bfb5e39937d107fcb180e20ca8e5a9a45ccea2a174e57bf2f179ce8f770"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cbb40565bcf16a755bfa0d841821c87683c62935a7fe8434bb3f6581c0a49c9f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d475013f99af865c3ba77f471d3f6016a7f73b1a3b63cd412720700b5a7f3a79"
    sha256 cellar: :any_skip_relocation, sonoma:        "cc89ae3533af7ecfb7f239c269c7df44fc31b7b752707d960fe4063ab51f5f54"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "646d7c3fa8b8e219708a4298b7deae7702442c1d6709b0f98ad58543950b7b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9798c9811bbfbb418a899cf53ad434977d89691cc36cbc9da48fe5bb84e6de00"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    system "cargo", "install", *std_cargo_args
  end

  service do
    run [opt_bin/"ironclaw", "run"]
    keep_alive true
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ironclaw --version")
    assert_match "Settings", shell_output("#{bin}/ironclaw config list")
  end
end
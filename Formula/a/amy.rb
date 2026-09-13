class Amy < Formula
  desc "Nostr client from the Amethyst project"
  homepage "https://github.com/vitorpamplona/amethyst"
  url "https://ghfast.top/https://github.com/vitorpamplona/amethyst/releases/download/v1.15.2/amy-1.15.2-jvm.tar.gz"
  sha256 "db354a7e9994f0f15b9a9c55596fec0e3d3bc4294a81455d6f35ad5ccefb4191"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4e7fecb202776ac6f508900f1f833ebf23535dd62c25a2d397119476221b6b4"
  end

  depends_on "openjdk"

  def install
    libexec.install Dir["*"]
    (bin/"amy").write_env_script libexec/"bin/amy", Language::Java.overridable_java_home_env
  end

  test do
    require "json"

    # NIP-19 bech32: a known key round-trips from hex to npub and back.
    hex = "3bf0c63fcb93463407af97a5e5ee64fa883d107ef9e558472c4eb9aaaefa459d"
    npub = "npub180cvv07tjdrrgpa0j7j7tmnyl2yr6yr7l8j4s3evf6u64th6gkwsyjh6w6"
    assert_match npub, shell_output("#{bin}/amy encode npub #{hex}")
    assert_equal hex, JSON.parse(shell_output("#{bin}/amy --json decode #{npub}"))["pubkey"]

    # secp256k1: the public key derived from a freshly minted secret key
    # matches the one minted alongside it.
    generated = JSON.parse(shell_output("#{bin}/amy --json key generate"))
    derived = JSON.parse(shell_output("#{bin}/amy --json key public #{generated["nsec"]}"))
    assert_equal generated["npub"], derived["npub"]
  end
end
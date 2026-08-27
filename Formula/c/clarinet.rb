class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https://stackslabs.com/"
  url "https://ghfast.top/https://github.com/stx-labs/clarinet/archive/refs/tags/v3.23.2.tar.gz"
  sha256 "896ac6410715c9e31e3cebdea63da1705df72018e65a2dd94265e287a63b53b3"
  license "GPL-3.0-only"
  version_scheme 1
  head "https://github.com/stx-labs/clarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "6d29eae4060064ed236971a407c3f76f42cbc59aaf22f0b55944353ba41e640c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42b55b6fd76778262bae61c1ea3769fc2b889753ea906379f234fa5bf67f261d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8dd85fbf573eda92b370ce6a07fd7c9eff985cc89485c72be69fc8b73071d78d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0be6aca06a304e4d21dd99418003d0ba4965369195fc4fef6d00f347f92a39df"
    sha256 cellar: :any,                 arm64_linux:   "d963739b01e691b640a656a06a91b01e3e94866658d98f27674bd88b6881c147"
    sha256 cellar: :any,                 x86_64_linux:  "a7b005dbce4064abaffceafcef4146415dee1c3dd7d73b2f33fd7770ff185e22"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "components/clarinet-cli")
  end

  test do
    pipe_output("#{bin}/clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath/"test-project/Clarinet.toml").read
    system bin/"clarinet", "check", "--manifest-path", "test-project/Clarinet.toml"
  end
end
class Buffrs < Formula
  desc "Modern protobuf package management"
  homepage "https://github.com/helsing-ai/buffrs"
  url "https://ghfast.top/https://github.com/helsing-ai/buffrs/archive/refs/tags/v0.13.1.tar.gz"
  sha256 "61453466055e446b124dae4359d3c17026b954bfee69b47db0c8c6b31dfce689"
  license "Apache-2.0"
  head "https://github.com/helsing-ai/buffrs.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "80a29e452541050a776191be6f756112bc30daa06d0a9673019b00dbe770c5be"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6907ac9b9d39ad3a5e7b85de8b31ab3db9f591902c30aff85bcbd0270fedc8cb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3f6341041ac3d4b27acb17927e1dd77bb370a53edb1525c30a43926a47378c51"
    sha256 cellar: :any_skip_relocation, sonoma:        "af35d715899450380b6b09fb41758545136c221609465a3b07db67dc3a222a4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61072ea1912aa449964d9e211acb9a3744a9d08a5c283f4124b09f2a6db7008d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "73742df959d4c9bbc0a382d8536f14cc575638364ce4a3621cad76b9f7eedb8a"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/buffrs --version")

    system bin/"buffrs", "init"
    assert_match "edition = \"#{version.major_minor}\"", (testpath/"Proto.toml").read

    assert_empty shell_output("#{bin}/buffrs list")
  end
end
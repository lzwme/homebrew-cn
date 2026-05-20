class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.9.0.tar.gz"
  sha256 "18ba1d317249fb8e4ac89f008a7e78e5dee02a2763bd574280b396758d4adabe"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c23e74e48b74806068b507328a1dae074e9217109abe87ceddce2b2d42a37ed8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b457fb820fd03e03e71abb5e1a54b76cb4d6de67f43b3dfb550b781a871b7c46"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6b758af8258b2752a3e22c292ddc772b0b9f17f84d407f1708fdc5cbe46658fe"
    sha256 cellar: :any_skip_relocation, sonoma:        "472f87fd5a2b2e90ef195f371d0514e939962f9e022cbf24e21398a81baf79da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9386ccf678a39378be7e9a1bb36cc508981f3e596c6689c9217b0fb2c7660970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a70607bccad8e9012c69eb7e611279da54d0112813d0e3ca577928e64fd280e"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssh"
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["RADICLE_VERSION"] = version.to_s

    %w[radicle-cli radicle-node radicle-remote-helper].each do |bin|
      system "cargo", "install", *std_cargo_args(path: "crates/#{bin}")
    end

    generate_completions_from_executable(bin/"rad", "completion")

    system "asciidoctor", "-b", "manpage", "-d", "manpage", "*.1.adoc"
    man1.install Dir["*.1"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/rad version")
    assert_match version.to_s, shell_output("#{bin}/radicle-node --version")

    assert_match "Your Radicle DID is", pipe_output("#{bin}/rad auth --alias homebrew --stdin", "homebrew", 0)
    assert_match "\"repos\": 0", shell_output("#{bin}/rad stats")
    system bin/"rad", "ls"

    assert_match "a passphrase is required", shell_output(bin/"radicle-node", 1)
  end
end
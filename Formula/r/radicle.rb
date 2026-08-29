class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.10.2.tar.gz"
  sha256 "4e8b124ecfb24706391c9a16d47ce4ea377a07385dfadf32f60be92cc1160ff7"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "3c9d8aa920f3e749472b3e936d9a2b187d1b0ab94386d4dd6e47be0be5243ff0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b38fffead7ade319d453c70397a0b91ade6308b2ad216896386ca9b84b4167b0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "327b7a52947c37fdefeedac8f930366942b0b1add37273131c389ccf0986f755"
    sha256 cellar: :any,                 arm64_linux:   "157bf9ee2b8a9f0c5093bddb67249feff73b4023a6ca523f38c7846e0e90e909"
    sha256 cellar: :any,                 x86_64_linux:  "9380d3b1a1a2984311672ffc6c2e4726d9d3910ac953452c560911339036b3df"
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
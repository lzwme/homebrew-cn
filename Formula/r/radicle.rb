class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.7.0.tar.gz"
  sha256 "6806a42aea75831037bb992881cd58680b9794cf76fc1c5bada98e53418d581b"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "97d2522d6ee9bc1c2df563018f2587a38b9d7e2001f1f0a266991693e84dd2d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "96886e6d55ac7d5ced083a6cd8d8f1f727f5af2d5e53504cd13fbb43a3c1c24b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "61e003a802363d21b7aa4705def39deec67c4dfdfdb971a59d2b724cfcfbeea2"
    sha256 cellar: :any_skip_relocation, sonoma:        "e7f5a01c3d30c08e6da3e52b4ea62aee7a6a0ac67680e7580eae93c71256a82b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e421678261a5a3daa478cfb8babc995241d3c883c3af5708e8a820661c5994c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a342d483535e21aa749ef8876c2c286bfa1a75380a0983589b82fcf881709b2e"
  end

  depends_on "asciidoctor" => :build
  depends_on "rust" => :build

  depends_on "openssh"

  on_linux do
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
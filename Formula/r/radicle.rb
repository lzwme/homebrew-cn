class Radicle < Formula
  desc "Sovereign code forge built on Git"
  homepage "https://radicle.xyz"
  url "https://files.radicle.xyz/releases/latest/heartwood-1.10.0.tar.gz"
  sha256 "2f91ff00d9a2cb333145daf2264e2e266be3322d31836b780d13dcbd29ea1568"
  license all_of: ["MIT", "Apache-2.0"]

  livecheck do
    url "https://files.radicle.xyz/releases/latest/radicle.json"
    strategy :json do |json|
      json["version"]
    end
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "435452eea9033206d2dc54de43484863f3681d19a26e3f382cdb6dd0ba77fef0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4595b738c21b118d724bd74e16197713117cfec257edc75ee286be043c241d6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "660b2dcb5c5ea625bc6144896a25a6dbd51c6627b664cf63e70cc52a91f1c082"
    sha256 cellar: :any_skip_relocation, sonoma:        "64700a3874910feea26975a1067b9d7c0ce5d1fa5cd72949ed3a29db697be89e"
    sha256 cellar: :any,                 arm64_linux:   "d1740041004099d03b257b801a8ec72772ce3b825480bbaba618092f093ab51c"
    sha256 cellar: :any,                 x86_64_linux:  "aaffdb76163e4ef1bd4ea930ae786c3a450a08d0372535a253d2fed1f57af6ea"
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
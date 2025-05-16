class Proto < Formula
  desc "Pluggable multi-language version manager"
  homepage "https:moonrepo.devproto"
  url "https:github.commoonrepoprotoarchiverefstagsv0.49.1.tar.gz"
  sha256 "a52d107dcd27088f7c5957c50beddc7bf264572b9211a1c9adda69bbeca72645"
  license "MIT"
  head "https:github.commoonrepoproto.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f948675b4f97fe1b693535e7889b39877565de431794df0417fca1c16c73203e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "640404e75f4ed2f31616b67ec355917a5a4b175dcc07ea0089000998524ab673"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "435b98997038400decc468f3255462af67958d11f720a7bc03fda7c639163765"
    sha256 cellar: :any_skip_relocation, sonoma:        "ff261d2845fa20ade56d1d05851779c8a9ee255369d8f4bf0c3981498ebdbc41"
    sha256 cellar: :any_skip_relocation, ventura:       "078957fe1f309d79682158a5acc47388d78873bf7815ddc53a611a85e9c58453"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ba9ce944d1765a7b89ff41a11affb0402bade5d59da5ff018c958fdbb44b46d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f95c44bf379c6ebed2c77b3407844106501bd4e0579fd14ca659bdc724e8988c"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "xz"
  end

  def install
    system "cargo", "install", *std_cargo_args(path: "cratescli")
    generate_completions_from_executable(bin"proto", "completions", "--shell")

    bin.each_child do |f|
      basename = f.basename

      # shimming proto-shim would break any shims proto itself creates,
      # it luckily works fine without PROTO_LOOKUP_DIR
      next if basename.to_s == "proto-shim"

      (libexec"bin").install f
      # PROTO_LOOKUP_DIR is necessary for proto to find its proto-shim binary
      (binbasename).write_env_script libexec"bin"basename, PROTO_LOOKUP_DIR: opt_prefix"bin"
    end
  end

  def caveats
    <<~EOS
      To finish the installation, run:
        proto setup
    EOS
  end

  test do
    system bin"proto", "install", "node", "19.0.1"
    node = shell_output("#{bin}proto bin node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")

    path = testpath"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}.protoshimsnode #{path}").strip
    assert_equal "hello", output
  end
end
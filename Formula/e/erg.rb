class Erg < Formula
  desc "Statically typed language that can deeply improve the Python ecosystem"
  homepage "https://github.com/erg-lang/erg"
  url "https://ghproxy.com/https://github.com/erg-lang/erg/archive/refs/tags/v0.6.26.tar.gz"
  sha256 "7dd5b4bc009ac51597d3ba8a5ebf317637d054bf36a8f8e85e663a25516b1a33"
  license any_of: ["Apache-2.0", "MIT"]

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ebca4449cd1cf8582a0a48f8986d2ec673af5cbb4bd936d0bfc5f3ba648559c2"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6ebb3edc2deb2d623eb5e6a7f554c9381738c9cd122965c329860052cdba0a05"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b42ec241a945d526cf75186a3809cb08af9b107c90ff8a87aa559167bc1bf3b"
    sha256 cellar: :any_skip_relocation, sonoma:         "4c12ede6aa7d6e6832103dd67177f0726dde0c98d4bb83110e3a4d971d9a12c9"
    sha256 cellar: :any_skip_relocation, ventura:        "a84ccb8bf3a91e27b981d8105db6175b71d9a26cade6fd8d47187611efe5b694"
    sha256 cellar: :any_skip_relocation, monterey:       "76ffef5ac9cbbe03522bd36e348ca6f9ef54bb2b76bb0b0b9bc6c91769035f59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "913f207af70727d53f5e99f055385aaf70f8631845fec7ea3cdcd74d57c87321"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    feature_args = "els,full-repl,unicode,backtrace"
    ENV["HOME"] = buildpath # The build will write to HOME/.erg
    system "cargo", "install", "--features", *feature_args, *std_cargo_args(root: libexec)
    pkgshare.install buildpath.glob(".erg/*")
    (bin/"erg").write_env_script(libexec/"bin"/"erg", ERG_PATH: pkgshare)
  end

  test do
    (testpath/"test.er").write <<~EOS
      print! "hello"
    EOS

    output = shell_output("#{bin}/erg lex #{testpath}/test.er")
    assert_equal "[Symbol print!, StrLit \"hello\", Newline \\n, EOF \u0000]\n", output

    output = shell_output("#{bin}/erg check #{testpath}/test.er")
    assert_match "\"hello\" (: {\"hello\"})", output

    assert_match version.to_s, shell_output("#{bin}/erg --version")
  end
end
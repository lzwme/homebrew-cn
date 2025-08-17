class Objconv < Formula
  desc "Object file converter"
  homepage "https://www.agner.org/optimize/#objconv"
  url "https://www.agner.org/optimize/objconv.zip"
  version "2025-08-16"
  sha256 "e259dd2e01e78311a7734fb2aedcf6a83ddf09360081dfe0968290db37b73039"
  license "GPL-3.0-or-later"

  livecheck do
    url :homepage
    regex(/objconv\.zip,.*?last\s+modified:\s+(\d{4}-(?:[a-z]+|\d{2})-\d{2})/im)
    strategy :page_match do |page, regex|
      date = page[regex, 1]
      next if date.blank?

      Date.parse(date).strftime("%Y-%m-%d")
    end
  end

  no_autobump! because: :incompatible_version_format

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b8f181b3a64a7c11181da86925b27ca86231fbc62f059038c5c715bab6ee08a2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0049fe7d738ab5a39fdc3872a58d881f944615d9464b4452ae65c2bd168faf3e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8b43d41ab2248e00bae0596a301e8a3d5cb0e1de945c448a726e76121f6ce24c"
    sha256 cellar: :any_skip_relocation, sonoma:        "9feacefd8ab6eb27ae77169bbcfe50f5806c17be83ef3aa4c86463983fade81e"
    sha256 cellar: :any_skip_relocation, ventura:       "889817d15dea9819fdafb4ebb21937cc8d56878b8d74e0c47603ede377a42ded"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7a1f0bbf352e70b3cc0045bb7966a2969d29ffe6dea4f4584581c23ab06e216a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c5c2f48ed76749420f2047060623b16337e322c4fb62c2efc6b7809485226ec"
  end

  uses_from_macos "unzip" => :build

  def install
    system "unzip", "source"
    system "./build.sh"

    bin.install "objconv"
    doc.install "objconv-instructions.pdf"
  end

  test do
    (testpath/"foo.c").write "int foo() { return 0; }\n"

    system "make", "foo.o"
    assert_match "foo", shell_output("nm foo.o")

    # Rename `foo` to `main`. At least one of `make` or `./bar` will fail if this did not succeed.
    sym_prefix = OS.mac? ? "_" : ""
    system bin/"objconv", "-nr:#{sym_prefix}foo:#{sym_prefix}main", "foo.o", "bar.o"
    system "make", "bar"
    refute_match "foo", shell_output("nm bar")
    system "./bar"
  end
end
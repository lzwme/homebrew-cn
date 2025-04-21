class Broot < Formula
  desc "New way to see and navigate directory trees"
  homepage "https:dystroy.orgbroot"
  url "https:github.comCanopbrootarchiverefstagsv1.46.1.tar.gz"
  sha256 "a760b6fa4ae3196f2b91ff2364aaded7acef45ff97e4ec8c5f06c749c17a745b"
  license "MIT"
  head "https:github.comCanopbroot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adc0970910c88ef54c94049184ae13a299e4cd2a66287077938d2f89f3f2a804"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a3f63d91db480500a2596f73d47e69a148a26e2a18cc3a80eaefeff925e11949"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "8ef1d5d0246fe9fb09f457c792795c7cb35181506f5853f6a739a14f8369b5ea"
    sha256 cellar: :any_skip_relocation, sonoma:        "4578ab2d045c6052f41b79e8ab32c01287ddd668ef61855b9bcf61c5da58b953"
    sha256 cellar: :any_skip_relocation, ventura:       "cf78239fbed637aa2969626a27f7c899a2f2211356e07dac1355419792d3f4cf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e529dfe06a6ebc19233c02174857fc6e638db6d2d5785cd9dbcaed56ba503f8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7c66d8e98b2a8c8323bd5d598091486585dbb72c4b38edc1c64473d96f8a37aa"
  end

  depends_on "rust" => :build
  depends_on "libxcb"

  uses_from_macos "curl" => :build
  uses_from_macos "zlib"

  def install
    system "cargo", "install", *std_cargo_args

    # Replace man page "#version" and "#date" based on logic in release.sh
    inreplace "manpage" do |s|
      s.gsub! "#version", version.to_s
      s.gsub! "#date", time.strftime("%Y%m%d")
    end
    man1.install "manpage" => "broot.1"

    # Completion scripts are generated in the crate's build directory,
    # which includes a fingerprint hash. Try to locate it first
    out_dir = Dir["targetreleasebuildbroot-*out"].first
    fish_completion.install "#{out_dir}broot.fish"
    fish_completion.install "#{out_dir}br.fish"
    zsh_completion.install "#{out_dir}_broot"
    zsh_completion.install "#{out_dir}_br"
    bash_completion.install "#{out_dir}broot.bash" => "broot"
    bash_completion.install "#{out_dir}br.bash" => "br"
  end

  test do
    output = shell_output("#{bin}broot --help")
    assert_match "lets you explore file hierarchies with a tree-like view", output
    assert_match version.to_s, shell_output("#{bin}broot --version")

    require "pty"
    require "ioconsole"
    PTY.spawn(bin"broot", "-c", ":print_tree", "--color", "no", "--outcmd", testpath"output.txt") do |r, w, pid|
      r.winsize = [20, 80] # broot dependency terminal requires width > 2
      w.write "n\r\n"
      output = ""
      begin
        r.each { |line| output += line }
      rescue Errno::EIO
        # GNULinux raises EIO when read is done on closed pty
      end
      assert_match "New Configuration files written in", output
      assert_predicate Process::Status.wait(pid), :success?
    end
  end
end
class Hl < Formula
  desc "Fast and powerful log viewer and processor"
  homepage "https://github.com/pamburus/hl"
  url "https://ghfast.top/https://github.com/pamburus/hl/archive/refs/tags/v0.33.1.tar.gz"
  sha256 "179d8e5072e83918f42c6bf5de9e7943426322f693a6872b035a4cd41771e4fe"
  license "MIT"
  head "https://github.com/pamburus/hl.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d40b689512725de188341a50c2efcbdc835ba2c7c752eca86a8fd0cbff86fa30"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7d2fc9620323308bf0fb454ecaf2c7688a8ccf2c41a6bcc20e720cf023e3a1cc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a97229a21aaf8d5bd6d474dc75150aa342b45eeb7d936ad93018236c0c0b69fa"
    sha256 cellar: :any_skip_relocation, sonoma:        "1d403613b3b979a4836b99d74ee249e0d95161055cc74615e7d989da3ae2c0d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "829f0e4496c790cd9febe46119c9875bec8281050a3f174aba7671fb86ca77b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5937426c1785e07b7d6cfff8d5e3554d4c263d779d113166f3d8db513b374e24"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"hl", "--shell-completions")
    (man1/"hl.1").write Utils.safe_popen_read(bin/"hl", "--man-page")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/hl --version")

    (testpath/"sample.log").write <<~EOS
      time="2025-02-17 12:00:00" level=INFO msg="Starting process"
      time="2025-02-17 12:01:00" level=ERROR msg="An error occurred"
      time="2025-02-17 12:02:00" level=INFO msg="Process completed"
    EOS

    output = shell_output("#{bin}/hl --level ERROR sample.log")
    assert_equal "Feb 17 12:01:00.000 [ERR] An error occurred", output.chomp
  end
end
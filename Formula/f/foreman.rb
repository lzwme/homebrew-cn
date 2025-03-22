class Foreman < Formula
  desc "Manage Procfile-based applications"
  homepage "https:ddollar.github.ioforeman"
  url "https:github.comddollarforemanarchiverefstagsv0.88.1.tar.gz"
  sha256 "78826feb7c7a580f4d4e6cb15f0d4373d8ec71eedaf67ae3263c36398c926c70"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "126259e9cf4cd9a74ed3ed9b5c42bf7999c3ba21109fa356a9a5da96e133d6a4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, sonoma:         "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, ventura:        "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, monterey:       "22db09f18f3ccbfec2cc743a006a1b1590ca09ec7561158b9cb7fc1f7bfd5ab1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "4bd3bde94b4e935314cccb59fefcc7b32d2297290c9f872122e59ee0308520cc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99fd4a76113c004e871f65c3d553b56168528ffa6d332fd944beecba1c244751"
  end

  uses_from_macos "ruby"

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files(libexec"bin", GEM_HOME: ENV["GEM_HOME"])
    man1.install "manforeman.1"
  end

  test do
    (testpath"Procfile").write("test: echo 'test message'")
    expected_message = "test message"
    assert_match expected_message, shell_output("#{bin}foreman start")
  end
end
class Sad < Formula
  desc "CLI search and replace | Space Age seD"
  homepage "https:github.comms-jpqsad"
  url "https:github.comms-jpqsadarchiverefstagsv0.4.32.tar.gz"
  sha256 "a67902b9edb287861668ee3e39482c17b41c60e244ece62b3f8016250286294f"
  license "MIT"
  head "https:github.comms-jpqsad.git", branch: "senpai"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc792df17bca12c265808a20efcbf4444fddf598e1b0671938f624d60a02f930"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "013696e18b0fd86010f790c555f8aa37c1f7058990fa4a4b2ceff65d17daaadc"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "49df2026de6f61f870fc3c23d286214842af83b0bb92ea8e7f9a2e005e8b0d88"
    sha256 cellar: :any_skip_relocation, sonoma:        "ac5f622402e313226339eb22f389fe826994ee8771b23cc28c2188ff81096f80"
    sha256 cellar: :any_skip_relocation, ventura:       "5afe1a5fac8625f958c34c4b7b030c4d4d6d3c3b7c7212988f19a8e7f6928f39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5eb56b7ce0c1cd515a1e2492614a4cbe2b3ea8e3652f0a9ad2a2ed43d9eec43b"
  end

  depends_on "rust" => :build

  uses_from_macos "python" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    test_file = testpath"test.txt"
    test_file.write "a,b,c,d,e\n1,2,3,4,5\n"
    system "find #{testpath} -name 'test.txt' | #{bin}sad -k 'a' 'test' > devnull"
    assert_equal "test,b,c,d,e\n1,2,3,4,5\n", test_file.read

    assert_match "sad #{version}", shell_output("#{bin}sad --version")
  end
end
class Krep < Formula
  desc "High-Performance String Search Utility"
  homepage "https:davidesantangelo.github.iokrep"
  url "https:github.comdavidesantangelokreparchiverefstagsv0.3.5.tar.gz"
  sha256 "dd29fcd022df00d32b68003b40110720ccfcd1772ccc70fca6e47229a6633ec2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b05f1973ff890f673296379b72e6a394b7b4943158c5effa3af6d7a4709e29c5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cee616f39b264cd813b3962a930a3bdec4b551555cb7e4eb0a34e1c3745759b9"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5db8da2e5cf97e08efb3e1ff03d7a94affa504ec9a1b66897690ff75c3a54bf3"
    sha256 cellar: :any_skip_relocation, sonoma:        "e776488b057c6bf69e9755749311f7f2c5740c5fd5f496c30e248dd7d5ce9993"
    sha256 cellar: :any_skip_relocation, ventura:       "38cbd219c2283d943b1d48a39592f44e76ccf89a0401a04a9bc5bcb778e22428"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "6699fa9409d759e6c62439e4ebc97148c0833c10a23366ae79f3908a8d588919"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f291e56c66ef4692ddc8866ae9fd57aaec105138172dc8578753055af529d2a4"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}krep -v", 1)

    text_file = testpath"file.txt"
    text_file.write "This should result in one match"

    output = shell_output("#{bin}krep -c 'match' #{text_file}").strip
    assert_match "1", output
  end
end
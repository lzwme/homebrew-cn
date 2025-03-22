class Tgpt < Formula
  desc "AI Chatbots in terminal without needing API keys"
  homepage "https:github.comaandrew-metgpt"
  url "https:github.comaandrew-metgptarchiverefstagsv2.9.2.tar.gz"
  sha256 "8ad477e8089b2b2b98f8d0fc9dcf367f1ef12e2a0abf427151fb2adfe10ebb5a"
  license "GPL-3.0-only"
  head "https:github.comaandrew-metgpt.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f5a563fe2d9ba268541a0cef460f7cf2078e244dfd95f4604463f69369eda541"
    sha256 cellar: :any_skip_relocation, sonoma:        "b93a4502723ce9a4cc043e571af57789a787267fec4c4eacc02b3d350e6619a2"
    sha256 cellar: :any_skip_relocation, ventura:       "b93a4502723ce9a4cc043e571af57789a787267fec4c4eacc02b3d350e6619a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a16a73e2753d143f50145323db94d00b38fe05bc468c6f0d991c768567f5d9f6"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}tgpt --version")

    output = shell_output("#{bin}tgpt --provider duckduckgo \"What is 1+1\"")
    assert_match "1 + 1 equals 2.", output
  end
end
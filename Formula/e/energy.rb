class Energy < Formula
  desc "CLI is used to initialize the Energy development environment tools"
  homepage "https:energye.github.io"
  url "https:github.comenergyeenergyarchiverefstagsv2.5.5.tar.gz"
  sha256 "23fc328279bcc9ccd04367d114a76b9fec89b2f5640e616f504479b9a72ed3f9"
  license "Apache-2.0"
  head "https:github.comenergyeenergy.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "88509bc73059ad17112c392e2f40a79ecd5801ab18efb9adc26f85f1c2be6a82"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "88509bc73059ad17112c392e2f40a79ecd5801ab18efb9adc26f85f1c2be6a82"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "88509bc73059ad17112c392e2f40a79ecd5801ab18efb9adc26f85f1c2be6a82"
    sha256 cellar: :any_skip_relocation, sonoma:        "cd8f3711a3f025f135b07a2ee18eb85b5cfab2fea279447c322159c89f6286b7"
    sha256 cellar: :any_skip_relocation, ventura:       "cd8f3711a3f025f135b07a2ee18eb85b5cfab2fea279447c322159c89f6286b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8c8c333664e7ea4e61893d95f521897c2f63bdffcf6d93b7d1668f2d712acdf"
  end

  depends_on "go" => :build

  def install
    cd "cmdenergy" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}energy cli -v")

    assert_match "https:energy.yanghy.cn", shell_output("#{bin}energy env")
  end
end
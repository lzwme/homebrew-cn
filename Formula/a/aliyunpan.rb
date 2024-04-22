class Aliyunpan < Formula
  desc "Command-line client tool for Alibaba aDrive disk"
  homepage "https:github.comtickstepaliyunpan"
  url "https:github.comtickstepaliyunpanarchiverefstagsv0.3.1.tar.gz"
  sha256 "6dec5a4249b60afd9e68041f853ea8ec9a994c81436e015059c997cf40554429"
  license "Apache-2.0"
  head "https:github.comtickstepaliyunpan.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "69ef75d372d9987b338f83a35f4f7f0bf63d2ac8570507741e69dee096916b20"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6340bdbc33e0644911adf6f8af8656f50a9bbd6731580802256c227c9dadd21"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdfe9b7406a067f1a9757fd45ba651aae15416c2180a029dd00e5a02ff7e2dc6"
    sha256 cellar: :any_skip_relocation, sonoma:         "e8ef4d4bc8553feee6a866b112e51cfa8cf443fe2fba8e4d70909d4320e14e33"
    sha256 cellar: :any_skip_relocation, ventura:        "ff691c818deaef5dfcc35769e6fcadb57f7d4177a8b674741dab32467e618613"
    sha256 cellar: :any_skip_relocation, monterey:       "4bc3d4640577947f4ba6c0c2dd564d1e3b51ff79171e7f4061adb5f9dd12c41f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "649a76113757dbf362f01165a5327a8e2a67f5569b1da30ef207b2ce5c9e782c"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    system bin"aliyunpan", "run", "touch", "output.txt"
    assert_predicate testpath"output.txt", :exist?
  end
end
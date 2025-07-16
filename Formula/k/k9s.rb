class K9s < Formula
  desc "Kubernetes CLI To Manage Your Clusters In Style!"
  homepage "https://k9scli.io/"
  url "https://github.com/derailed/k9s.git",
      tag:      "v0.50.8",
      revision: "855e995b3a45583e112a4e43a95b1cb5debea5ba"
  license "Apache-2.0"
  head "https://github.com/derailed/k9s.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "0d4dab604e2866f0b444bea90795b3ea6ff4eafe9dbc06f7cdbc3943b67fe13e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2ca1c2bd537f6c53e637f45b27fe97ea8ff73c5b4140285dc4e81adafa2ee1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1f8bcd9ea45f6b1a8095bad60da8c2da99ea29b420d35ae997433ebebf823523"
    sha256 cellar: :any_skip_relocation, sonoma:        "de25da82607d05c68997eb5ad67da666910aea372017f4fa3e6110bccc94d0dd"
    sha256 cellar: :any_skip_relocation, ventura:       "ac1e4fe26e119b38bbb5fd38f0059eb3ec1ee157e8d46d28b9c441f5d3e6cc4a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c2e627872e2c27e527ce425a7caef7d9c85033d8fda97282f693e20ae94d0bc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "00b740b7fa7cf992d82e224fd1d0ae3ecfb1fd5c62006c09d1ba3efa48106f81"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/derailed/k9s/cmd.version=#{version}
      -X github.com/derailed/k9s/cmd.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"k9s", "completion")
  end

  test do
    assert_match "K9s is a CLI to view and manage your Kubernetes clusters.",
                 shell_output("#{bin}/k9s --help")
  end
end
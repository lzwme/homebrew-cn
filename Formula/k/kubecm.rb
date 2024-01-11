class Kubecm < Formula
  desc "KubeConfig Manager"
  homepage "https:kubecm.cloud"
  url "https:github.comsunny0826kubecmarchiverefstagsv0.27.0.tar.gz"
  sha256 "6ce8802571be851e99603713cc638023776da0d2120cdc7d137a8e9319453f73"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1c42e2197c1a33c74e3fff36d5c98138fe8ec3cc9cd09e7278a284662392c69a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b152a27d9edf096c4ca808521251e1bbb44874c9e35920f5abf4ec6a2044b693"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "671fc756b14ef8186e43b29bfe4efc8ad7ac777d752415129b612e3d5f2f845c"
    sha256 cellar: :any_skip_relocation, sonoma:         "c6ec76c98ab1e9e30d71894b3f84ca97331c27e46f8c02277f43adee00ba5090"
    sha256 cellar: :any_skip_relocation, ventura:        "50d77340cc2cd7e8d037cbdd9fe96f6541a566738dd0fbcd0d41c81121b8f6c1"
    sha256 cellar: :any_skip_relocation, monterey:       "0ca555e826502624a0733f9e3e3a18058f5001d4be26e5e05bdee26f932f2b65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3407fbb7b94799b099db6eea23ddd80fd3fb576ffbc5ca511bdb269617f99df8"
  end

  depends_on "go" => :build

  # patch to use go1.21 for build
  # upstream pr ref, https:github.comsunny0826kubecmpull847
  patch do
    url "https:github.comsunny0826kubecmcommite8bcf31999e9629eb68174ee817b6f1c1b2951a3.patch?full_index=1"
    sha256 "63a48460535c857b804095eedea8d91c2dc42f76c9fd5d8004213dbdd6fe925f"
  end

  def install
    ldflags = "-s -w -X github.comsunny0826kubecmversion.Version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin"kubecm", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}kubecm version")
    # Should error out as switch context need kubeconfig
    assert_match "Error: open", shell_output("#{bin}kubecm switch 2>&1", 1)
  end
end
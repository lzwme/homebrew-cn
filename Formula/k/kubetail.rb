class Kubetail < Formula
  desc "Logging tool for Kubernetes with a real-time web dashboard"
  homepage "https:www.kubetail.com"
  url "https:github.comkubetail-orgkubetailarchiverefstagscliv0.4.3.tar.gz"
  sha256 "b608fcf479c213e79f7dc76b35efc4426a045c9ee87e761804b1f12d49f0558c"
  license "Apache-2.0"
  head "https:github.comkubetail-orgkubetail.git", branch: "main"

  livecheck do
    url :stable
    regex(%r{^cliv?(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a007ad2c94dc129e5295e0a8d7c68e4c614050a861922f225827d8fcb03e78c2"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7e5aa98952e37656c92bc66fce22178a3c3f0db84b84844882515b3f6cd901a2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5831c504113efda761249347b9fb362570bcb8e0b130d87fb1c37dc45ef89e05"
    sha256 cellar: :any_skip_relocation, sonoma:        "9e06cd71fb22392b4a51f78985874a3d8033639a9a2acb300687019f93737049"
    sha256 cellar: :any_skip_relocation, ventura:       "2d7e443af962a8e0d0068fcd8e5201bd5aead9dc946adcde36d299af9aa983d9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17c432d0d8aa0fd4043426d8e2a0b15cf98d89d7301f86c0ba2ca8dbd8b3c673"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "700090163ce1cff8ab3f0779432a346705409161d42e44dd34da6984d1cdb5f5"
  end

  depends_on "go" => :build
  depends_on "make" => :build
  depends_on "node" => :build
  depends_on "pnpm" => :build

  def install
    system "make", "build", "VERSION=#{version}"
    bin.install "binkubetail"
    generate_completions_from_executable(bin"kubetail", "completion")
  end

  test do
    command_output = shell_output("#{bin}kubetail serve --test")
    assert_match "ok", command_output

    assert_match version.to_s, shell_output("#{bin}kubetail --version")
  end
end
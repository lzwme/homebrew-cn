class RubyLsp < Formula
  desc "Opinionated language server for Ruby"
  homepage "https:shopify.github.ioruby-lsp"
  url "https:github.comShopifyruby-lsparchiverefstagsv0.23.13.tar.gz"
  sha256 "80f67f7afe9d069d752cda5853ffec7f7484616ff0063290b346ec7ccb7efbf7"
  license "MIT"
  head "https:github.comShopifyruby-lsp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7906816c7d5b984c92c86910116e167fa186841d60e05484246236b6371563c2"
    sha256 cellar: :any,                 arm64_sonoma:  "4adc6c11d35031019b9586b46c84d0f4bdbceeb6e495ae9ffdad82c6a0f7656f"
    sha256 cellar: :any,                 arm64_ventura: "85eb5dc95a64e0cc5825ebf9f5aa77ef0b99f7c6ef6f3883ddeef5fc4ccb1a40"
    sha256 cellar: :any,                 sonoma:        "4363d8d21f032442d24d321154788e8c14f5212a25000847dd05106b45bb8c73"
    sha256 cellar: :any,                 ventura:       "4d96b84cf032616a23432a1ca529350edefb54a055121a7ea8dc60c1a4180c1c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "494dbd447b1b04d276ce73e014f5141468324769ec2610416df8898254498e60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b1680b960b43877000af2d76d1a0da31b79f33613011541d5ca1d378180a6934"
  end

  depends_on "ruby"

  def install
    ENV["GEM_HOME"] = libexec

    system "bundle", "install", "--without", "development", "test"
    system "gem", "build", "#{name}.gemspec"
    system "gem", "install", "#{name}-#{version}.gem"
    bin.install libexec"bin#{name}"
    bin.env_script_all_files libexec"bin", GEM_HOME: ENV["GEM_HOME"]
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}ruby-lsp 2>&1", input, 0)
    assert_match(^Content-Length: \d+i, output)
  end
end
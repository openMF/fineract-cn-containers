/*
 * Licensed to the Apache Software Foundation (ASF) under one
 * or more contributor license agreements.  See the NOTICE file
 * distributed with this work for additional information
 * regarding copyright ownership.  The ASF licenses this file
 * to you under the Apache License, Version 2.0 (the
 * "License"); you may not use this file except in compliance
 * with the License.  You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing,
 * software distributed under the License is distributed on an
 * "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
 * KIND, either express or implied.  See the License for the
 * specific language governing permissions and limitations
 * under the License.
 */
package org.apache.fineract.cn.dev;

import java.util.Properties;

import org.apache.fineract.cn.lang.security.RsaKeyPairFactory;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Qualifier;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.test.context.junit4.SpringRunner;

@SuppressWarnings("SpringAutowiredFieldsWarningInspection")
@RunWith(SpringRunner.class)
@SpringBootTest()
public class Provisioner {
  private static final String TEST_LOGGER = "test-logger";

  @Configuration
  public static class TestConfiguration {
    public TestConfiguration() {
      super();
    }

    @Bean(name = TEST_LOGGER)
    public Logger logger() {
      return LoggerFactory.getLogger(TEST_LOGGER);
    }
  }

  private RsaKeyPairFactory.KeyPairHolder keyPairHolder;

  @Autowired
  @Qualifier(TEST_LOGGER)
  private Logger logger;

  public Provisioner() {
    super();
  }

  @Test
  public void provisionRSAKeys() {
    System.out.println("Generating RSA Keys ...");
    this.keyPairHolder = RsaKeyPairFactory.createKeyPair();
    logger.info("system.PUBLIC_KEY_TIMESTAMP " + this.keyPairHolder.getTimestamp());
    logger.info("system.PUBLIC_KEY_MODULUS " + this.keyPairHolder.publicKey().getModulus().toString());
    logger.info("system.PUBLIC_KEY_EXPONENT " + this.keyPairHolder.publicKey().getPublicExponent().toString());
    logger.info("system.PRIVATE_KEY_MODULUS " + this.keyPairHolder.privateKey().getModulus().toString());
    logger.info("system.PRIVATE_KEY_EXPONENT " + this.keyPairHolder.privateKey().getPrivateExponent().toString());
  }

}
